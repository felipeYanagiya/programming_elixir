defmodule Exerc_2 do
  def maxThree(a,b,c) do
    Enum.reduce([a,b,c],
      fn
        x, acc when x < acc -> acc
        x, _acc -> x
      end)
  end

  def howManyEqual(a,b,c) do
    cond do
      a == b and a == c -> 3
      a == b and a != c -> 2
      a != b and b == c -> 2
      a == c and a != b -> 2
      true -> 0
    end
  end
end
