defmodule Bumper.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/fdate/:ticker" do
    booger = crap(ticker)
    send_resp(conn, 200, "#{booger}")
  end

  get "/shazam/:ticker" do
    booger = shmap(ticker)
    send_resp(conn, 200, "#{booger}")
  end

  match _ do
    send_resp(conn, 200, "use /shazam/ticker or /fdate/ticker returns most recent filing date/time")
  end

  def crap(ticker) do
    shmuck = shmucker(ticker)

    if length(shmuck) > 1 do
      shmuck
      |> tl()
      |> crapper()
      |> yuk(~r{\<td\>\d\d\d\d\-\d\d\-\d\d\<\/td\>})
      |> crapper()
    else
      nil
    end
  end

  def shmap(ticker) do
    shmuck = shmucker(ticker)

    date =
      if length(shmuck) > 1 do
        shmuck
        |> tl()
        |> crapper()
        |> yuk(~r{20(0|1)\d\-(0|1)\d\-(0|1|2|3)\d})
        |> crapper()
      else
        nil
      end

    form =
      if length(shmuck) > 1 do
        shmuck
        |> tl()
        |> crapper()
        |> yuk(~r{(SC 13|8\-K|10\-Q|10\-K|11\-K|SD|DEFA14A|S\-3|S\-2|S\-1)})
        |> crapper()
      else
        nil
      end

    "#{form}:#{date}"
  end

  def shmucker(ticker) do
    :httpc.request(
      'https://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&CIK=#{ticker}&owner=exclude&count=40'
    )
    |> humpty()
    |> String.split("Format")
  end

  def crapper(fart) do
    if fart == nil do
      nil
    else
      hd(fart)
    end
  end

  def humpty(dumpty) do
    {_, {_, _, doodle}} = dumpty

    doodle
    |> to_string()
  end

  def yuk(guk, duk) do
    Regex.run(duk, guk)
  end
end
