defmodule Identicon do
  def main(input) do
    input
    |> hash_input()
    |> pick_color()
    |> build_grid()
    |> filter_odd_squares()
    |> build_pixel_map()
    |> draw_image()
    |> save_image(input)
  end

  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    image = :edg.create(250, 250)
    fill = :edg.color(color)

    Enum.each(pixel_map, fn {start, stop} ->
      :edg.filledRectangle(image, start, stop, fill)
    end)

    :edg.render(image)

    image
  end

  def save_image(image, input) do
    File.write("#{input}.png", image)
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map =
      Enum.map(grid, fn {_code, index} ->
        horizontal = rem(index, 5) * 50
        vertical = div(index, 5) * 50
        top_left = {horizontal, vertical}
        bottom_right = {horizontal + 50, vertical + 50}
        {top_left, bottom_right}
      end)

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  def pick_color(%Identicon.Image{hex: [red, green, blue | _tail]} = image) do
    %Identicon.Image{image | color: {red, green, blue}}
  end

  def mirror_row([first, second | _tail] = row) do
    row ++ [second, first]
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.map(&mirror_row/1)
      |> List.flatten()
      |> Enum.with_index()

    %Identicon.Image{image | grid: grid}
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid =
      Enum.filter(grid, fn {binary, _index} ->
        rem(binary, 2) == 0
      end)

    %Identicon.Image{image | grid: grid}
  end

  @doc """
  ## Example

    iex> Identicon.hash_input("Bob")
    [47, 193, 192, 190, 185, 146, 205, 112, 150, 151, 92, 254, 191, 157, 92, 59]
  """
  def hash_input(input) do
    hex =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list()

    %Identicon.Image{hex: hex}
  end
end
