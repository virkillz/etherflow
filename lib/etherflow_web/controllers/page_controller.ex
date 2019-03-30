defmodule EtherflowWeb.PageController do
  use EtherflowWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def match(conn, %{"from" => from, "to" => to}) do
    result =
      case Etherflow.find_relationship(from, to) do
       %{address: address, origin: origin, result: [%{"p" => p, "x" => x}] } ->
          %{error: [], results: [%{columns: ["user", "entity"], data: [%{graph: %{nodes: Enum.map(p.nodes, fn x -> change_label(x, address, origin) end), relationships: Enum.map(x, fn y -> add_start_end(y) end)}}]}]}
        [] -> %{error: [], results: []}
        _ -> %{error: ["cannot connect to database"], results: []}
      end

    json(conn, result)
  end

  def add_start_end(x) do
    x |> Map.put(:startNode, x.start) |> Map.put(:endNode, x.end)
  end


  def change_label(x, address, origin) do
    cond do
      x.properties["address"] == address -> x
      x.properties["address"] == origin -> Map.put(x, :labels, ["Bad Address"])
      true -> Map.put(x, :labels, ["Transit"])
    end
  end

  def match(conn, _params) do
    json(conn, %{success: false, reason: "need 'from' and 'to' ETH address as paramater"})
  end

  def query(conn, %{"q" => q}) do
    result =
      case Etherflow.query(q) do
        [%{"p" => p}] -> IO.inspect(p)
          %{error: [], results: p}
        [] -> %{error: [], results: []}
        _ -> %{error: ["cannot connect to database"], results: []}
      end

    json(conn, result)    
  end  
end
