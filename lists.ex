defmodule MyLists do
  @tax_rates [ NC: 0.075, TX: 0.08 ]

  def sum([total | rest]) do
    cond do
      rest == [] -> total
      true -> sum([total + hd(rest) | tl(rest)])
    end
  end

  def mapsum(list, func) do
    Enum.map(list, func)
    |> Enum.reduce(&(&1 + &2))
  end

  def caesar(list, n) do
    Enum.map(list, fn (char) -> if char + n > 122 do nil else char + n end end)
    |> Enum.filter(fn char -> char != nil end)
  end

  defp my_all?(list, funct, acc) do
    cond do
      acc == false or acc == nil -> false
      list == [] -> true
      true -> my_all?(tl(list), funct, funct.(hd(list)))
    end
  end

  def my_all?(list, funct \\ fn x -> x end) do
    my_all?(list, funct, true)
  end

  def my_each(list, funct) do
    cond do
      list == [] -> :ok
      true ->
        funct.(hd(list))
        my_each(tl(list), funct)
    end
  end

  defp my_filter(list, funct, filtered) do
    cond do
      list == [] -> filtered
      # SHOULD use Enum.reverse and [hd(list) | filtered] for concatenation
      funct.(hd(list)) == true -> my_filter(tl(list), funct, filtered ++ [hd(list)])
      true -> my_filter(tl(list), funct, filtered)
    end
  end

  def my_filter(list, funct) do
    my_filter(list, funct, [])
  end

#   iex> Enum.split([1, 2, 3], 2)
# {[1, 2], [3]}
#
# iex> Enum.split([1, 2, 3], 10)
# {[1, 2, 3], []}
#
# iex> Enum.split([1, 2, 3], 0)
# {[], [1, 2, 3]}
#
# iex> Enum.split([1, 2, 3], -1)
# {[1, 2], [3]}
#
# iex> Enum.split([1, 2, 3], -5)
# {[], [1, 2, 3]}

  defp my_split(list, number, {old, new}) do
    cond do
      number == 0 -> result
      true -> my_split(tl(list), number - 1, { hd(list) ++ old, })
    end
  end

  def my_split(list, 0) do
    {[], list}
  end

  def my_split(list, number) do

  end
  #
  # Takes the first count items from the enumerable.
  # count must be an integer. If a negative count is given, the last count values will be taken.
  # For such, the enumerable is fully enumerated keeping up to 2 * count elements in memory. Once
  # the end of the enumerable is reached, the last count elements are returned.
  #
  #  Examples
  #
  # iex> Enum.take([1, 2, 3], 2)
  # [1, 2]
  #
  # iex> Enum.take([1, 2, 3], 10)
  # [1, 2, 3]
  #
  # iex> Enum.take([1, 2, 3], 0)
  # []
  #
  # iex> Enum.take([1, 2, 3], -1)
  # [3]

  def my_take() do
  end

  defp flatten(list, nested, acc) do
    cond do
      is_list(hd(nested)) == true -> flatten(list, hd(nested) ++ tl(nested), acc)
      Enum.empty?(tl(nested)) != true -> flatten(list, tl(nested), [hd(nested) | acc])
      true -> flatten(list, [hd(nested) | acc])
    end
  end

  defp flatten(list, acc) do
    cond do
      Enum.empty?(list) -> Enum.reverse(acc)
      is_list(hd(list)) == true -> flatten(tl(list), hd(list), acc)
      true -> flatten(tl(list), [hd(list) | acc])
    end
  end

  def flatten(list) do
    flatten(list, [])
  end

  defp span(num1, num2, acc) do
    cond do
      num1 <= num2 -> span(num1 + 1, num2, [num1 | acc])
      true -> acc
    end
  end

  defp span_prime(num1, num2, acc) do
    cond do
      num1 <= num2 and is_prime(num1) -> span_prime(num1 + 1, num2, [num1 | acc])
      num1 <= num2 -> span_prime(num1 + 1, num2, acc)
      true -> acc
    end
  end

  def span(num1, num2) do
    span(num1, num2, [])
  end

  def is_prime(num) do
    not Enum.any?(2..num-1, fn x -> rem(num, x) == 0 end)
  end

#  def is_prime(x), do: (2..x |> Enum.filter(fn a -> rem(x, a) == 0) |> length()) == 1
#  def prime(n), do: Stream.interval(1) |> Stream.drop(2) |> Stream.filter(&is_prime/1) |> Enum.take(n)

  def prime_range(n) do
    span_prime(2, n, [])
    |> Enum.reverse
  end



# order
# [id: 12, ship_to: :NC, net_amount:100.00]

# finding tax
# Enum.filter(tax_rates, fn {x, tax} -> x == tax end)

  defp find_order_attr(list, attr) do
    cond do
      elem(hd(list), 0) == attr -> elem(hd(list), 1)
      true -> find_order_attr(tl(list), attr)
    end
  end

  defp calc_tax(order) do
    tax = Enum.filter(@tax_rates, fn {x, _tax} -> x == find_order_attr(order, :ship_to) end)
    cond do
      not Enum.empty?(tax) -> (1 + elem(hd(tax), 1)) * find_order_attr(order, :net_amount)
      true -> find_order_attr(order, :net_amount)
    end
  end

  def tax(orders) do
    IO.inspect(orders)
    Enum.map(orders, fn order -> order ++ [{:total_amount, calc_tax(order)}] end)
  end
#   Exercise: ListsAndRecursion-8
# The Pragmatic Bookshelf has offices in Texas (TX) and North Carolina
# (NC), so we have to charge sales tax on orders shipped to these states.
# The rates can be expressed as a keyword list: 2
# tax_rates = [ NC: 0.075, TX: 0.08 ]
# Here’s a list of orders:
# [
# [ id: 123, ship_to: :NC, net_amount: 100.00 ],
# [ id: 124, ship_to: :OK, net_amount: 35.50 ],
# [ id: 125,ship_to: :TX, net_amount: 24.00 ],
# [ id: 126,ship_to: :TX, net_amount: 44.80 ],
# [ id: 127,ship_to: :NC, net_amount: 25.00 ],
# [ id: 128,ship_to: :MA, net_amount: 10.00 ],
# [ id: 129,ship_to: :CA, net_amount: 102.00 ],
# [ id: 130,ship_to: :NC, net_amount: 50.00 ] ]
# Write a function that takes both lists and returns a copy of the orders,
# but with an extra field, total_amount , which is the net plus sales tax. If a
# shipment is not to NC or TX, there’s no tax applied.

end
