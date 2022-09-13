defmodule Invoicex.Invoices.Template do
  require Logger

  defstruct entries: []

  def load(args) do
    template_dir = Keyword.fetch!(args, :template_dir)

    entries =
      Path.wildcard("#{template_dir}/*")
      |> Enum.map(&check_detail/1)
      |> Enum.map(&load_detail(&1, template_dir))
      |> Enum.filter(fn t -> !is_nil(t) end)

    Logger.info("#{length(entries)} template(s) successfully loaded")
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
        Logger.info("template dir #{dir} found, but invalid!")
        nil
    end
  end

  defp load_detail(nil, _), do: nil

  defp load_detail({html_path, json_path, img_path}, template_dir) do
    with {:ok, body} <- File.read(json_path),
         {:ok, %{"id" => _, "name" => _, "description" => _, "author" => _, "source" => _} = meta} <-
           Jason.decode(body) do
      meta
      |> Map.put("html_path", html_path)
      |> Map.put(
        "html_url",
        Path.join("/", Path.relative_to(html_path, Path.dirname(template_dir)))
      )
      |> Map.put(
        "img_url",
        Path.join("/", Path.relative_to(img_path, Path.dirname(template_dir)))
      )
    else
      _ ->
        Logger.info("template meta #{json_path} found, but invalid!")
        nil
    end
  end
end

defmodule Invoicex.Invoices.TemplateServer do
  use GenServer
  require Logger
  alias Invoicex.Invoices.Template

  def start_link(_opts) do
    template_dir =
      Application.app_dir(:invoicex, [Application.fetch_env!(:invoicex, :invoice_templates_dir)])

    Logger.info("starting template server with template dir: #{template_dir}")
    GenServer.start_link(__MODULE__, template_dir, name: __MODULE__)
  end

  # interfaces

  def list do
    GenServer.call(__MODULE__, :list)
  end

  # callbacks
  @impl GenServer
  def init(template_dir) do
    {:ok, {template_dir, nil}, {:continue, :load_templates}}
  end

  @impl GenServer
  def handle_continue(:load_templates, {template_dir, _}) do
    {:noreply, {template_dir, Template.load(template_dir: template_dir)}}
  end

  @impl GenServer
  def handle_call(:list, _caller, {template_dir, template}) do
    {:reply, Template.list(template), {template_dir, template}}
  end
end
