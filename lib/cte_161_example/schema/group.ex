defmodule Group do
  use Ecto.Schema
  import Ecto.Changeset

  import Ecto.Query

  @primary_key {:id, :id, source: :F_GroupID, autogenerate: true}

  schema "T_Groups" do
    field :name, :string, source: :F_GroupName, null: false

    # Group hierarchy
    belongs_to :parent, __MODULE__, source: :F_GroupParentID
    has_many :children, __MODULE__, foreign_key: :parent_id
  end
end
