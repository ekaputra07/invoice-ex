defmodule Invoicex.Invoices.Template do
  require Logger

  defstruct entries: []

  def load({root, dir}) do
    entries =
      Path.wildcard("#{root}/#{dir}/*")
      |> Enum.map(&check_detail/1)
      |> Enum.map(fn t -> load_detail(t, root) end)
      |> Enum.filter(fn t -> !is_nil(t) end)

    Logger.debug("#{length(entries)} template(s) successfully loaded")
    %Invoicex.Invoices.Template{entries: entries}
  end

  def list(%Invoicex.Invoices.Template{} = template), do: template.entries

  defp check_detail(dir) do
    html_path = Path.join(dir, "invoice.html")
    json_path = Path.join(dir, "invoice.json")
    img_path = Path.join(dir, "invoice.png")

    # only load template when all mandatory files exists
    with true <- File.exists?(html_path),
         true <- File.exists?(json_path),
         true <- File.exists?(img_path) do
      {html_path, json_path, img_path}
    else
      _ ->
        Logger.debug("template dir #{dir} found, but invalid!")
        nil
    end
  end

  defp load_detail(nil, _), do: nil

  defp load_detail({html_path, json_path, img_path}, root) do
    with {:ok, body} <- File.read(json_path),
         {:ok, %{"id" => _, "name" => _, "description" => _, "author" => _, "source" => _} = meta} <-
           Jason.decode(body) do
      meta
      |> Map.put("html_path", html_path)
      |> Map.put("html_url", Path.join("/", Path.relative_to(html_path, root)))
      |> Map.put("img_url", Path.join("/", Path.relative_to(img_path, root)))
    else
      _ ->
        Logger.debug("template meta #{json_path} found, but invalid!")
        nil
    end
  end
end

defmodule Invoicex.Invoices.TemplateServer do
  use GenServer
  require Logger
  alias Invoicex.Invoices.Template

  def start_link(_opts) do
    root = Application.fetch_env!(:invoicex, :invoice_templates_root)
    dir = Application.fetch_env!(:invoicex, :invoice_templates_dir)
    Logger.debug("starting template server with root dir: #{root}")
    GenServer.start_link(__MODULE__, {root, dir}, name: __MODULE__)
  end

  # interfaces

  def list do
    GenServer.call(__MODULE__, :list)
  end

  # callbacks
  @impl GenServer
  def init(root_dir) do
    {:ok, {root_dir, nil}, {:continue, :load_templates}}
  end

  @impl GenServer
  def handle_continue(:load_templates, {root_dir, _}) do
    {:noreply, {root_dir, Template.load(root_dir)}}
  end

  @impl GenServer
  def handle_call(:list, _caller, {root_dir, template}) do
    {:reply, Template.list(template), {root_dir, template}}
  end
end
