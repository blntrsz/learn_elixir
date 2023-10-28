defmodule Cards do
  @moduledoc """
    Provides methods for creating and handling a deck of cards
  """
  @type deck() :: list(String)

  @doc """
    Returns a list of strings representing a deck of playing cards
  """
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

  @doc """
    Determines whather a deck contains a given card

  ## Examples
    
    iex> deck = Cards.create_deck
    iex> Cards.contains?(deck, "Ace of Spades")
    true
  """
  @spec contains?(deck :: deck(), card :: String) :: boolean
  def contains?(deck, card) do
    Enum.member?(deck, card)
  end

  @doc """
    Divides a deck into a hand and the remainder of the deck.
    The `hand_size` argument indicated how many cards should be in hand.

  ## Examples
    
    iex> deck = Cards.create_deck
    iex> {hand, _deck} = Cards.deal(deck, 1)
    iex> hand
    ["Ace of Spades"]
  """
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
