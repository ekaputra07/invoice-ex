# Invoice-ex

Invoice-ex is a simple web app to automate the creation and sending of invoice in PDF format that can be scheduled on specific interval (recurring) or one time in the future. Builts using [Phoenix framework](https://www.phoenixframework.org/) and of course [Elixir](https://elixir-lang.org/).

![screenshot](https://raw.githubusercontent.com/ekaputra07/invoice-ex/main/screenshot.png)

## A bit of background
Since the beginning of 2022, I'm officially became an *independent remote contractor* that requires me to send invoice every month to the company I work for.

They provide me with an invoice template, I just need to adjust it little bit (invoice number, dates etc.) before sending it to our finance departement. The process only took me a couple of minute but its **so boring and error prone** (manually changing dates here and there, incrementing invoice number) which is not a big deal and a small mistake won't prevent you from getting paid.

But recently I'm also decided to learn Elixir and its web framework Phoenix, I'm more than happy to solve a couple of minute boring task with a couple of week development time which is totally worthed from the learning perspective.

So here it is. Now I have new skillset (Elixir and Phoenix) and got my invoice generated and delivered to me every month automatically. Sweet!

If you're interested trying without deploying yourself, please let me know. I have it deployed and running in the cloud, happy to open it for public use in case somebody interested.

## Development

Its just standard Phoenix framework app with PostgreSQL database.

I provided `dev.sh` script that you can execute and it will spin up development environment without having to install Erlang and Elixir manually on your machine.

```
./dev.sh
```

Once inside, you need to run these commands:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## License
```
MIT License

Copyright (c) 2022 Eka Putra

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

```
