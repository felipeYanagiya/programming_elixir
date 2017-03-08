defmodule Airport do
  @moduledoc """
  Documentation for Airport.
  """

  require Logger

  def fetch(url) do
    Logger.info "Fetching airport"
    url
    |> HTTPoison.get
    |> handle_response
  end

  def handle_response({:ok, %{status_code: 200, body: body}}) do
    Logger.info "Successful response"
    Logger.debug fn -> inspect(body) end
    { :ok, body }
   end

  def handle_response({_, %{status_code: status, body: body}}) do
    Logger.error "Error #{status} returned"
    { :error, Poison.Parser.parse!(body) }
  end

  @doc """
  Hello world.

  ## Examples

      iex> Airport.hello
      :world

  """
  def hello do
    :world
  end
end
