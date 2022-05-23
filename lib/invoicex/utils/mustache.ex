defmodule Invoicex.Utils.Mustache do
  use Timex

  def render(template) do
    now = Timex.now()
    # current end-of-month
    eom = Timex.end_of_month(now)
    # next beginning-of-month
    next_bom = Timex.shift(eom, days: 1)
    next_eom = Timex.end_of_month(next_bom)

    macros = %{
      # now
      date: now |> Calendar.strftime("%x"),
      date_nodash: now |> Calendar.strftime("%Y%m%d"),
      time: now |> Calendar.strftime("%X"),
      date_time: now |> Calendar.strftime("%c"),
      day_of_year: now |> Calendar.strftime("%j"),
      year: now |> Calendar.strftime("%Y"),
      year_2d: now |> Calendar.strftime("%y"),
      month: now |> Calendar.strftime("%m"),
      month_abbr: now |> Calendar.strftime("%b"),
      month_full: now |> Calendar.strftime("%B"),
      day: now |> Calendar.strftime("%d"),
      day_abbr: now |> Calendar.strftime("%a"),
      day_full: now |> Calendar.strftime("%A"),
      hour: now |> Calendar.strftime("%H"),
      hour_12: now |> Calendar.strftime("%I"),
      minute: now |> Calendar.strftime("%M"),
      second: now |> Calendar.strftime("%S"),
      # current eom
      eom_date: eom |> Calendar.strftime("%x"),
      eom_date_nodash: eom |> Calendar.strftime("%Y%m%d"),
      eom_time: eom |> Calendar.strftime("%X"),
      eom_date_time: eom |> Calendar.strftime("%c"),
      eom_day_of_year: eom |> Calendar.strftime("%j"),
      eom_year: eom |> Calendar.strftime("%Y"),
      eom_year_2d: eom |> Calendar.strftime("%y"),
      eom_month: eom |> Calendar.strftime("%m"),
      eom_month_abbr: eom |> Calendar.strftime("%b"),
      eom_month_full: eom |> Calendar.strftime("%B"),
      eom_day: eom |> Calendar.strftime("%d"),
      eom_day_abbr: eom |> Calendar.strftime("%a"),
      eom_day_full: eom |> Calendar.strftime("%A"),
      eom_hour: eom |> Calendar.strftime("%H"),
      eom_hour_12: eom |> Calendar.strftime("%I"),
      eom_minute: eom |> Calendar.strftime("%M"),
      eom_second: eom |> Calendar.strftime("%S"),
      # next bom
      next_bom_date: next_bom |> Calendar.strftime("%x"),
      next_bom_date_nodash: next_bom |> Calendar.strftime("%Y%m%d"),
      next_bom_time: next_bom |> Calendar.strftime("%X"),
      next_bom_date_time: next_bom |> Calendar.strftime("%c"),
      next_bom_day_of_year: next_bom |> Calendar.strftime("%j"),
      next_bom_year: next_bom |> Calendar.strftime("%Y"),
      next_bom_year_2d: next_bom |> Calendar.strftime("%y"),
      next_bom_month: next_bom |> Calendar.strftime("%m"),
      next_bom_month_abbr: next_bom |> Calendar.strftime("%b"),
      next_bom_month_full: next_bom |> Calendar.strftime("%B"),
      next_bom_day: next_bom |> Calendar.strftime("%d"),
      next_bom_day_abbr: next_bom |> Calendar.strftime("%a"),
      next_bom_day_full: next_bom |> Calendar.strftime("%A"),
      next_bom_hour: next_bom |> Calendar.strftime("%H"),
      next_bom_hour_12: next_bom |> Calendar.strftime("%I"),
      next_bom_minute: next_bom |> Calendar.strftime("%M"),
      next_bom_second: next_bom |> Calendar.strftime("%S"),
      # next eom
      next_eom_date: next_eom |> Calendar.strftime("%x"),
      next_eom_date_nodash: next_eom |> Calendar.strftime("%Y%m%d"),
      next_eom_time: next_eom |> Calendar.strftime("%X"),
      next_eom_date_time: next_eom |> Calendar.strftime("%c"),
      next_eom_day_of_year: next_eom |> Calendar.strftime("%j"),
      next_eom_year: next_eom |> Calendar.strftime("%Y"),
      next_eom_year_2d: next_eom |> Calendar.strftime("%y"),
      next_eom_month: next_eom |> Calendar.strftime("%m"),
      next_eom_month_abbr: next_eom |> Calendar.strftime("%b"),
      next_eom_month_full: next_eom |> Calendar.strftime("%B"),
      next_eom_day: next_eom |> Calendar.strftime("%d"),
      next_eom_day_abbr: next_eom |> Calendar.strftime("%a"),
      next_eom_day_full: next_eom |> Calendar.strftime("%A"),
      next_eom_hour: next_eom |> Calendar.strftime("%H"),
      next_eom_hour_12: next_eom |> Calendar.strftime("%I"),
      next_eom_minute: next_eom |> Calendar.strftime("%M"),
      next_eom_second: next_eom |> Calendar.strftime("%S")
    }

    template
    |> Mustache.render(macros)
  end
end
