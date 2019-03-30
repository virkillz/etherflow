defmodule Etherflow do
  @moduledoc """
  Etherflow keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias Etherflow.Eth

  def start(number) when is_integer(number) do
    case Eth.get_block_by_number(number, true) do
      {:ok, %{"result" => %{"transactions" => transactions}}} ->
        Enum.each(transactions, fn x -> store(x) end)

      error ->
        error
    end

    start(number + 1)
  end

  def start() do
  	IO.puts("Connecting to neo4j....")
  	Bolt.Sips.start_link(Application.get_env(:bolt_sips, Bolt))
  	Process.sleep(5_000)
  number =
   case get_last_block_processed() do
   	[%{"max(r.block_int)" => result}] -> result
   		_ -> 46146
    end

    IO.puts("Start getting transaction from block #{number}")
    start(number)
  end

  def store(%{
        "blockNumber" => block_number,
        "from" => from,
        "to" => to,
        "gas" => gas,
        "gasPrice" => gas_price,
        "hash" => hash,
        "input" => "0x",
        "value" => value
      }) do

    query = 
    """
    MERGE (a:Address { address: '#{from}'}) 
    MERGE (b:Address { address: '#{to}'}) 
    MERGE (a)-[r:TransferETHTo { block: '#{block_number}' , gas: '#{gas}', gas: '#{gas_price}', block_int: #{parse_hex(block_number)}, hash: '#{hash}', input: '0x', value: '#{value}', value_int: '#{parse_hex(value)}' }]->(b)
    RETURN a,r,b
    """

    Bolt.Sips.query!(Bolt.Sips.conn(), query)
  end

  def store(_any) do
    :ignore
  end

  def get_last_block_processed() do
    query = "match (a)-[r:TransferETHTo]->(b) return max(r.block_int)"

    Bolt.Sips.query!(Bolt.Sips.conn(), query)
  end

  def find_relationship(address, origin) do
    query = """
    MATCH (n {address: '#{origin}'}),(m {address: '#{address}'}),
    p = shortestPath((n)-[x:TransferETHTo*..15]-(m)) 
    RETURN p,x,n,m
    """

    result = Bolt.Sips.query!(Bolt.Sips.conn(), query)

    %{address: address, origin: origin, result: result}
  end


  def query(q) do
    Bolt.Sips.query!(Bolt.Sips.conn(), q) |> IO.inspect
  end

  def parse_hex(hex_string) when is_binary(hex_string) do
    "0x" <> hex = hex_string
    {integer, _} = Integer.parse(hex, 16)
    integer
  end  
end
