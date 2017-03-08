defmodule Compound do

  ### we want to calculate, how much is need to have
  ### a monthly rate
  def rate_amount(monthly_rate, interest) do
    trunc(monthly_rate * 12 / interest)
  end
  
  def calculate(initial, rate, time) do
    initial * :math.pow((1+rate/12), 12 * time)
  end

  defp future_value(deposit, rate, time) do
    deposit * ((:math.pow((1 + rate/12), 12 * time) -1) * 12/rate)
  end

  defp amount_invested(deposit, time) do
    deposit * 12 * time
  end

  defp tax(gains) do
    gains * 0.15
  end

  defp profit(total, deposit, time) do
    total - tax(total - amount_invested(deposit, time))
  end

  def calculate_with_tax(initial, deposit, rate, time) do
    profit(calculate(initial, rate, time) + future_value(deposit, rate, time), deposit, time)
  end

  def calculate(initial, deposit, rate, time) do
    calculate(initial, rate, time) + future_value(deposit, rate, time)
  end

# Total = [ Compound interest for principal ] + [ Future value of a series ]
# Total = [ P(1+r/n)^(nt) ] + [ PMT × (((1 + r/n)^nt - 1) / (r/n)) ]

  defp calc_inss_salary(salary) do
    cond do
      salary <= 1556.94 -> salary * 0.92
      salary <= 2594.92 -> salary * 0.91
      salary <= 5189.82 -> salary * 0.89
      true -> salary - 570.88
    end
  end

  defp calc_irs_salary(salary) do
    cond do
      salary <= 1903.98 -> salary
      salary <= 2826.65 -> salary - (salary * 0.075 - 142.80)
      salary <= 3751.05 -> salary - (salary * 0.15 - 354.8)
      salary <= 4664.68 -> salary - (salary * 0.225 - 636.13)
      true -> salary - (salary * 0.275 - 869.36)
    end
  end

  def calculate_net_salary(gross_income) do
    calc_inss_salary(gross_income)
    |> calc_irs_salary
  end

  defp break_string(str) do
    String.split(String.trim(str), ",")
  end

  defp calculate({x, y, _direction}) do
    Kernel.abs(x) + Kernel.abs(y)
  end

  defp calculate_direction(list, coordinates) do
    if (Enum.count(list) == 0) do
      calculate(coordinates)
    else
      calculate_direction(tl(list), adjust_coordinates(coordinates, String.trim(hd(list))))
    end
  end

  defp get_blocks_walked(footprint) do
    String.to_integer(String.slice(footprint, 1, String.length(footprint)))
  end

  defp adjust_coordinates({x, y, "N"}, footprint) do
    cond do
      String.first(footprint) == "L" -> {x - get_blocks_walked(footprint), y, "W"}
      true -> {x + get_blocks_walked(footprint), y, "E"}
    end
  end

  defp adjust_coordinates({x, y, "W"}, footprint) do
    cond do
      String.first(footprint) == "L" -> {x, y - get_blocks_walked(footprint), "S"}
      true -> {x, y + get_blocks_walked(footprint), "N"}
    end
  end

  defp adjust_coordinates({x, y, "E"}, footprint) do
    cond do
      String.first(footprint) == "L" -> {x, y + get_blocks_walked(footprint), "N"}
      true -> {x, y - get_blocks_walked(footprint), "S"}
    end
  end

  defp adjust_coordinates({x, y, "S"}, footprint) do
    cond do
      String.first(footprint) == "L" -> {x + get_blocks_walked(footprint), y, "E"}
      true -> {x - get_blocks_walked(footprint), y, "W"}
    end
  end

  def no_time_taxi(string) do
    list = break_string(string)
    calculate_direction(list, {0, 0, "N"})
  end

  def place_visit_twice(string) do
    break_string(string)
  end

end
