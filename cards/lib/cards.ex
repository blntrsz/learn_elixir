defmodule Cards do
  @type deck() :: list(String)

  @spec create_deck() :: deck()
  def create_deck do
    values = ["Ace", "Two", "Three", "Four", "Five"]
    suits = ["Spades", "Cluds", "Hearts", "Diamonds"]

    for suit <- suits, value <- values do
      "#{value} of #{suit}"
    end
  end

  @spec shuffle(deck :: deck()) :: list(String)
  def shuffle(deck) when is_list(deck) do
    Enum.shuffle(deck)
  end

  @spec contains?(deck :: deck(), card :: String) :: boolean
  def contains?(deck, card) do
    Enum.member?(deck, card)
  end

  @spec deal(deck :: deck(), hand_size :: integer()) :: {list(String), list(String)}
  def deal(deck, hand_size) when is_list(deck) and is_integer(hand_size) do
    Enum.split(deck, hand_size)
  end

  def safe(deck, filename) do
    binary = :erlang.term_to_binary(deck)
    File.write(filename, binary)
  end

  def load(filename) do
    case File.read(filename) do
      {:ok, binary} -> :erlang.binary_to_term(binary)
      {:error, _} -> "That file does not exist"
    end
  end

  def create_hand(hand_size) do
    Cards.create_deck()
    |> Cards.shuffle()
    |> Cards.deal(hand_size)
  end
end
