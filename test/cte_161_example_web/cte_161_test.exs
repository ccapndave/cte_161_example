defmodule CTE161Test do
  @moduledoc """
    Given a group hierarchy like this:

    - a
      - a1
        - a11

    we run a CTE to get all ancestors from a node up to the root (where the root has `parent_id == nil`).
  """
  use Cte161Example.DataCase

  setup do
    {:ok, group_a} = Repo.insert(%Group{name: "A"})
    {:ok, group_a1} = Repo.insert(%Group{name: "A1", parent_id: group_a.id})
    {:ok, group_a11} = Repo.insert(%Group{name: "A11", parent_id: group_a1.id})

    {:ok, group_a: group_a, group_a1: group_a1, group_a11: group_a11}
  end

  test "it works with a fragment", %{group_a: group_a, group_a1: group_a1, group_a11: group_a11} do
    query =
      {"group_tree", Group}
      |> recursive_ctes(true)
      |> with_cte("group_tree",
        as:
          fragment(
            ~s(SELECT * FROM T_Groups WHERE F_GroupID=?
             UNION ALL
             SELECT parent.* FROM T_Groups parent INNER JOIN group_tree ON parent.F_GroupID=group_tree.F_GroupParentID),
            ^group_a11.id
          )
      )

    result = Repo.all(query)
    expected = [group_a11, group_a1, group_a]

    assert Enum.map(result, & &1.id) == Enum.map(expected, & &1.id)
  end

  test "it fails with composition", %{group_a: group_a, group_a1: group_a1, group_a11: group_a11} do
    initial_query =
      Group
      |> where([g], g.id == ^group_a11.id)

    recursion_query =
      Group
      |> join(:inner, [parent], tree in "group_tree", on: parent.parent_id == tree.id)

    ancestors_query = union_all(initial_query, ^recursion_query)

    query =
      {"group_tree", Group}
      |> recursive_ctes(true)
      |> with_cte("group_tree", as: ^ancestors_query)

    result = Repo.all(query)
    expected = [group_a11, group_a1, group_a]

    assert Enum.map(result, & &1.id) == Enum.map(expected, & &1.id)
  end
end
