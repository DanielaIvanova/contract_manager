defmodule ContractManager.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Comeonin.Bcrypt

  schema "users" do
    field(:email, :string)
    field(:encrypted_password, :string)
    field(:encrypted_password_confirmation, :string, virtual: true)
    field(:name, :string)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :encrypted_password, :encrypted_password_confirmation])
    |> validate_required([:name, :email, :encrypted_password, :encrypted_password_confirmation])
    |> unique_constraint(:email)
    |> validate_format(
      :email,
      ~r/^[A-Za-z0-9._%+-+']+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/,
      message: "Email is invalid"
    )
    |> validate_length(:encrypted_password, min: 8, max: 100)
    |> validate_confirmation(
      :encrypted_password,
      message: "The password confirmation doesn't match"
    )
    |> update_change(:encrypted_password, &Bcrypt.hashpwsalt/1)
  end
end
