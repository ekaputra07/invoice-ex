defmodule Invoicex.Utils.Mustache do
  def render(template) do
    rd = DateTime.utc_now()

    macros = %{
      date: rd |> Calendar.strftime("%x"),
      date_nodash: rd |> Calendar.strftime("%Y%m%d"),
      time: rd |> Calendar.strftime("%X"),
      date_time: rd |> Calendar.strftime("%c"),
      day_of_year: rd |> Calendar.strftime("%j"),
      year: rd |> Calendar.strftime("%Y"),
      year_2d: rd |> Calendar.strftime("%y"),
      month: rd |> Calendar.strftime("%m"),
      month_abbr: rd |> Calendar.strftime("%b"),
      month_full: rd |> Calendar.strftime("%B"),
      day: rd |> Calendar.strftime("%d"),
      day_abbr: rd |> Calendar.strftime("%a"),
      day_full: rd |> Calendar.strftime("%A"),
      hour: rd |> Calendar.strftime("%H"),
      hour_12: rd |> Calendar.strftime("%I"),
      minute: rd |> Calendar.strftime("%M"),
      second: rd |> Calendar.strftime("%S")
    }

    template
    |> Mustache.render(macros)
  end
end
