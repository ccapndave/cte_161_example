defmodule Cte161Example.Repo.Migrations.MakeGroup do
  use Ecto.Migration

  def change do
    create table("T_Groups", primary_key: false) do
      add :F_GroupID, :serial, primary_key: true
      add :F_GroupName, :string, null: false
      add :F_GroupParentID, references("T_Groups", column: :F_GroupID)
    end
  end
end
