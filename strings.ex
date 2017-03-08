defmodule Strings do

  def palindrome(char) do
    String.trim(to_string(char)) == String.trim(to_string(Enum.reverse(char)))
  end

  def anagram(word1, word2) do
    Enum.sort(word1) == Enum.sort(word2)
  end

  defp parse_number(input, val) do
    cond do
      #32 == space
      hd(input) == 32 -> elem(Integer.parse(String.trim(to_string(val))), 0)
      true -> parse_number(tl(input), val ++ input)
    end
  end

  def parse_number(input) do
    parse_number(input, '')
  end

  defp parse_last_number(input, val, acc) do
      
    cond do
      input == [] -> elem(Integer.parse(String.trim(to_string(val))), 0)
      hd(input) == 32 -> parse_last_number(tl(input), val, acc + 1)
      hd(input) != 32 and acc == 2 -> parse_last_number(tl(input), val ++ [hd(input)], acc)
      true -> parse_last_number(tl(input), val, acc)
    end
  end 


  def parse_last_number(input) do
    parse_last_number(input, '', 0)
  end

  defp multiply(num1, num2), do: num1 * num2    
  defp sum(num1, num2), do: num1 + num2
  defp divide(num1, num2), do: num1/num2
  defp minus(num1, num2), do: num1 - num2

  defp parse_op(input, num1, num2) do
    next_char = hd(input)
        
    cond do
      next_char == 42 -> multiply(num1,num2)
      next_char == 43 -> sum(num1,num2)
      next_char == 45 -> minus(num1,num2)
      next_char == 47 -> divide(num1,num2)
      true -> parse_op(tl(input), num1, num2)
    end
  end

  def calculator(calc_input) do
    num1 = parse_number(calc_input)
    num2 = parse_last_number(calc_input)
    parse_op(calc_input, num1, num2)
  end

# E.g.                           
#  ta . asdda Worf. catDog.
#  Ta . Asdda worf. Catdog.
# iex> capitalize_sentences("oh. a DOG. woof. ")
# "Oh. A dog. Woof. "
# First word capitalize, every first word after dot capitalizes others lowercase

  defp break_words(sentence) do
    String.split(sentence, ".")
  end

  defp capitalize_first_word(word) do
    String.capitalize(word)
  end

  defp capitalize_words(word) do
    String.capitalize(String.slice(word, 1, String.length(word)))
  end

  defp merge_words(first, []) do
    first
  end

  defp merge_words(first, rest) do
    merge_words(Enum.join([first, hd(rest)], ". "), tl(rest))
  end

  def capitalize_sentences(sentence) do
    phrases = String.split(sentence, ".")
    first_word =
      hd(phrases)
      |> capitalize_first_word
    others = 
      tl(phrases)
      |> Enum.map(fn word -> capitalize_words(word) end)
    merge_words(first_word, others)
  end

# Chapter 7 had an exercise about calculating sales tax on page 110. We 
# now have the sales information in a file of comma-separated id , ship_to ,
# and amount values. The file looks like this:
# id,ship_to,net_amount
# 123,:NC,100.00
# 124,:OK,35.50
# 125,:TX,24.00
# 126,:TX,44.80
# 127,:NC,25.00
# 128,:MA,10.00
# 129,:CA,102.00
# 120,:NC,50.00
# Write a function that reads and parses this file and then passes the result
# to the sales_tax function. Remember that the data should be formatted into
# a keyword list, and that the fields need to be the correct types (so the id
# field is an integer, and so on).
  defp get_row(line) do
    String.trim(line)
    |> String.replace("\n", "")
    |> String.split(",")
  end

  defp convert_types([id, state, amount]) do
    [
      id |> String.to_integer, 
      state |> String.replace(":", "") |> String.to_atom, 
      amount |> String.to_float
    ]
  end

  def parse_sales_tax(file) do
    {_status, read_file} = File.open(file, [:utf8, :read])

    header = 
      IO.read(read_file, :line)
      |> get_row
      |> Enum.map(&String.to_atom/1)

    cols =
      IO.stream(read_file, :line)
      |> Stream.map(&get_row/1)
      |> Stream.map(&convert_types/1)
      |> Stream.map(&(Enum.zip([header, &1])))
      |> Enum.to_list

  end

end
