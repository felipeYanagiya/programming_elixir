defmodule Functions do
  def my_map(list) do
    Enum.map(list, &(&1 + 2))
  end

  def my_each(list) do
    Enum.each(list, &(IO.inspect &1))
  end

  defp sum(n, acc) do
    cond do
      n == 0 -> acc
      true -> sum(n - 1, acc + n)
    end
  end

  def sum(n) do
    sum(n, 0)
  end

  def gcd(x, y) do
    cond do
      y == 0 -> x
      true -> gcd(y, rem(x,y))
    end
  end

  def convert_float(number) do
    {float_num, _rest} = :string.to_float(to_charlist(number))
    :io_lib.format("~.2f", [float_num])
    |> hd
    |> to_string
  end

  def get_system_env(variable) do
    System.get_env(variable)
  end

  def get_file_ext(file) do
    Path.extname(file) 
  end
end
