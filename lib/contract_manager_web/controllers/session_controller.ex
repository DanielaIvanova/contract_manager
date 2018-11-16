defmodule ContractManagerWeb.SessionController do
  use ContractManagerWeb, :controller

  alias ContractManager.Accounts

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => auth_params}) do
    user = Accounts.get_by_email(auth_params["email"])

    case Comeonin.Bcrypt.check_pass(user, auth_params["password"]) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:info, "Signed in successfully.")
        |> redirect(to: page_path(conn, :index))

      {:error, _} ->
        conn
        |> put_flash(:error, "There was a problem with your email/password")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:current_user_id)
    |> put_flash(:info, "Signed out successfully.")
    |> redirect(to: page_path(conn, :index))
  end
end
