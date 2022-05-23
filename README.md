# Invoice-ex

Invoice-ex is a simple web app to automate the creation and sending invoice in PDF format that can be scheduled on specific interval (recurring) or one time in the future. Builts on [Phoenix framework](https://www.phoenixframework.org/) and of course [Elixir programming language](https://elixir-lang.org/).


## A bit of background
Since the beginning of 2022, I'm officially became *independent remote contractor* that requires me to send invoice every month to the company I work for to get payment for my work.

They provides me with an invoice template, I just need to adjust it little bit (invoice number, dates etc.) before sending it to our finance departement. This process of *adjusting* only took me a couple of minutes and **honestly its sooo boring and error prone** (need to calculate the dates manually, increments the invoice number manually) which is not a big deal, since this is just a kind of formality and a small mistake won't prevent you from getting paid.

But recently I'm also start learning Elixir and its web framework Phoenix, so I'm more than happy to solve those couple of minute boring process with couple of week development time which is totally worthed from learning perspective.

So here it is. Now I have new skillset (Elixir and Phoenix) and got my invoice delivered to me at specific date every month. Sweet!

If you're interested using it without deploying it yourself, please let me know. I have it deployed and running for myself, but happy to open it for public if anyone interested.

## Development

Its just standard Phoenix framework app with PostgreSQL database.

I provides `dev.sh` which you can execute and it will setup development environment for you.

```
./dev.sh
```

Once inside you need to run these commands:

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