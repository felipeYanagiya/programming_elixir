defmodule MyLists do
  defp span_prime(num1, num2, acc) do
    cond do
      num1 <= num2 and is_prime(num1) -> span_prime(num1 + 1, num2, [num1 | acc])
      num1 <= num2 -> span_prime(num1 + 1, num2, acc)
      true -> acc
    end
  end

  defp is_prime(num) do
    not Enum.any?(2..num-1, fn x -> rem(num, x) == 0 end)
  end

  def prime_range(n) do
    span_prime(2, n, [])
    |> Enum.reverse
  end
end

IO.inspect MyLists.prime_range(15000)
