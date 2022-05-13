defmodule Invoicex.Utils.PDF do
  def html_to_pdf(html, api_key) do
    url = "https://v2.api2pdf.com/wkhtml/pdf/html"
    headers = [Authorization: api_key, Accept: "Application/json; Charset=utf-8"]

    payload = %{
      html: html,
      inline: false,
      fileName: "test.pdf",
      options: %{
        orientation: "Portrait",
        pageSize: "A4"
      },
      enableToc: false,
      useCustomStorage: false
    }

    {:ok, response} = HTTPoison.post(url, Jason.encode!(payload), headers)

    with %{body: body, status_code: 200} <- response,
         %{"FileUrl" => file_url} <- Jason.decode!(body) do
      {:ok, file_url}
    else
      _ -> {:error, {response.status_code, response.body}}
    end
  end
end
