defmodule Eigen.Matrix do
  @doc """
      iex> Eigen.Matrix.normalize([2.0,4.0])
      [1.0, 2.0]
  """
  def normalize(l) do
    l0 = hd(l)

    l
    |> Enum.map(&(&1 / l0))
  end

  @doc """
      iex> Eigen.Matrix.rate([2.0,4.0,5.0])
      [1.0, 0.25]
  """
  def rate(l) do
    plus = Enum.slice(l, 1..-1)

    l
    |> Enum.zip(plus)
    |> Enum.map(fn {a, b} -> (b - a) / a end)
  end

  @doc """
      writes vector to out.txt
     in gnuplot format
  """
  def w(l) do
    s =
      l
      |> Enum.reverse()
      |> Enum.reduce(fn x, y -> "#{x}\n#{y}\n" end)

    File.write("out.txt", s)
  end

  @doc """
      iex> Eigen.Matrix.addindex([[2,4],[3,7]])
      [[0,1],[2,4],[3,7]]
  """
  def addindex(m) do
    index = 0..(length(hd(m)) - 1) |> Enum.map(& &1)
    [index | m]
  end

  @doc """
      iex> Eigen.Matrix.ttostring({0, 1, 2})
      "0 1 2"
  """
  def ttostring(t) do
    t
    |> Tuple.to_list()
    |> Enum.reduce(&"#{&2} #{&1}")
  end

  @doc """
      #iex> Eigen.Matrix.mtostring([[0,1],[2,3]])
      #"0 2\n1 3"
  """
  def mtostring(m) do
    m
    |> Enum.zip()
    |> Enum.map(&ttostring(&1))
    |> Enum.reduce(&(&2 <> "\n" <> &1))
  end

  @doc """
      writes matrix to out.txt
     in gnuplot format
  """
  def ww(m) do
    File.write("out.txt", mtostring(m))
  end

  @doc """
      iex> Eigen.Matrix.dot([0,1],[2,3])
      3
  """
  def dot(l1, l2) do
    [l1, l2]
    |> Enum.zip()
    |> Enum.map(fn {x1, x2} -> x1 * x2 end)
    |> Enum.reduce(&(&1 + &2))
  end

  @doc """
      iex> Eigen.Matrix.transpose([[0,1],[2,3]])
      [[0,2],[1,3]]
  """
  def transpose(m) do
    m
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list(&1))
  end

  @doc """
      iex> Eigen.Matrix.mdot([[0,1],[2,3]], [4,5])
      [5, 23]
  """
  def mdot(m, l) do
    m
    |> Enum.map(&dot(&1, l))
  end

  @doc """
      iex> Eigen.Matrix.corr([[0,1,2],[1,2,3],[2,3,4]])
      [[5, 8, 11], [8, 14, 20], [11, 20, 29]]
  """
  def corr(m) do
    m
    |> Enum.map(&Enum.map(m, fn x -> dot(x, &1) end))
  end

  @doc """
      iex> Eigen.Matrix.xl_mult(2, [2,3])
      [4,6]
  """
  def xl_mult(x, l) do
    l
    |> Enum.map(&(&1 * x))
  end

  @doc """
      iex> Eigen.Matrix.xm_mult(2, [[2,3],[1,2]])
      [[4,6],[2,4]]
  """
  def xm_mult(x, m) do
    m
    |> Enum.map(&xl_mult(x, &1))
  end

  @doc """
      iex> Eigen.Matrix.svd([[2,3],[1,2]]) |> elem(1)
      [4.23606798, 0.23606798]
  """
  def svd(m) do
    if :erlang.whereis(:fart) == :undefined do
      {:ok, pid} = :python.start()
      :erlang.register(:fart, pid)
      :python.call(:fart, :functs, :svdcmp, [m])
    else
      :python.call(:fart, :functs, :svdcmp, [m])
    end
    |> Kernel.to_string()
    |> String.split("array")
    |> tl()
    |> Enum.map(&String.replace(&1, "(", ""))
    |> Enum.map(&String.replace(&1, ")", ""))
    |> Enum.map(&String.replace(&1, "\n      ", ""))
    |> Enum.map(&String.replace(&1, "]], ", "]]"))
    |> Enum.map(&String.replace(&1, "], ", "]"))
    |> Enum.map(&String.replace(&1, "][", "], ["))
    |> Enum.map(&Code.eval_string(&1))
    |> Enum.map(&bip(&1))
    |> List.to_tuple()
  end

  @doc """
      iex> Eigen.Matrix.average([[2,3],[1,2]])
      [1.5,2.5]
  """
  def average(m) do
    dim = length(m) / 1.0

    m
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list(&1))
    |> Enum.map(&Enum.reduce(&1, fn x, y -> x + y end))
    |> Enum.map(&(&1 / dim))
  end

  @doc """
      iex> Eigen.Matrix.llsub([2,3],[1,2])
      [1,1]
  """
  def llsub(l1, l2) do
    [l1, l2]
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list(&1))
    |> Enum.map(&Enum.reduce(&1, fn x1, x2 -> x2 - x1 end))
  end

  @doc """
      iex> Eigen.Matrix.lladd([2,3],[1,2])
      [3,5]
  """
  def lladd(l1, l2) do
    [l1, l2]
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list(&1))
    |> Enum.map(&Enum.reduce(&1, fn x1, x2 -> x1 + x2 end))
  end

  @doc """
      iex> Eigen.Matrix.bip({:a, :b})
      :a
  """
  def bip({a, _}), do: a
  def bop({_, b}), do: b
end
