defmodule Validacion do
  @moduledoc """
  Módulo encargado de validar los pesajes según las 5 reglas de negocio.
  """

  def validar_pesaje(pesaje, recolectores, lotes) do
    with {:ok, _} <- validar_recolector(pesaje.recolector, recolectores),
         {:ok, _} <- validar_lote(pesaje.lote, lotes),
         {:ok, _} <- validar_dia(pesaje.dia),
         {:ok, _} <- validar_kilos(pesaje.kilos),
         {:ok, _} <- validar_verdes(pesaje.verdes) do
      {:ok, pesaje}
    end
  end

  defp validar_recolector(codigo, recolectores) do
    if Enum.any?(recolectores, fn r -> r.codigo == codigo end) do
      {:ok, true}
    else
      {:error, :recolector_desconocido}
    end
  end

  defp validar_lote(id, lotes) do
    if Enum.any?(lotes, fn l -> l.id == id end) do
      {:ok, true}
    else
      {:error, :lote_desconocido}
    end
  end

  defp validar_dia(dia) do
    if is_integer(dia) and dia >= 1 and dia <= 6 do
      {:ok, true}
    else
      {:error, :dia_invalido}
    end
  end

  defp validar_kilos(kilos) do
    if is_number(kilos) and kilos > 0 and kilos <= 250 do
      {:ok, true}
    else
      {:error, :kilos_fuera_de_rango}
    end
  end

  defp validar_verdes(verdes) do
    if is_number(verdes) and verdes >= 0 and verdes <= 100 do
      {:ok, true}
    else
      {:error, :porcentaje_invalido}
    end
  end
end
