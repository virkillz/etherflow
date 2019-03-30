defmodule Etherflow.Eth do
  @spec call(String.t(), list(any())) :: tuple()
  def call(method, param) do
    url = Application.get_env(:neo4j, :url)
    headers = [{"Content-type", "application/json"}]
    body = Jason.encode!(%{"jsonrpc" => "2.0", "id" => 42, "method" => method, "params" => param})

    result = HTTPoison.post(url, body, headers, [])

    case result do
      {:ok, %{body: body, status_code: 200}} -> {:ok, Jason.decode!(body)}
      {:ok, %{body: body, status_code: code}} -> {:error, "We got status code: #{code}"}
      error -> error
    end
  end

  # Etherflow.get_block_by_number(1, true)

  @spec get_block_by_number(integer(), boolean()) :: tuple()
  def get_block_by_number(number, is_detail) when is_integer(number) do
    hex_number =
      number
      |> Integer.to_string(16)
      |> add_0x

    call("eth_getBlockByNumber", [hex_number, is_detail])
  end

  @spec get_block_by_number(String.t(), boolean()) :: tuple()
  def get_block_by_number(number, is_detail) when is_binary(number) do
    call("eth_getBlockByNumber", [number, is_detail])
  end

  @spec block_number() :: tuple()
  def block_number() do
    call("eth_blockNumber", [])
  end

  @spec block_number() :: integer() | :error
  def block_number!() do
    case call("eth_blockNumber", []) do
      {:ok, %{"id" => 42, "jsonrpc" => "2.0", "result" => result}} -> result
      _error -> :error
    end
  end

  @spec add_0x(String.t()) :: String.t()
  def add_0x(string) when is_binary(string) do
    "0x" <> string
  end
end
