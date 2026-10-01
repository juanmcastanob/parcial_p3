defmodule Liquidacion do
  @moduledoc """
  Lógica de liquidación. Todas las funciones aquí son funciones puras.
  """

  @tarifa_base 1000
  @bono_kilos 120
  @bono_pago 8000
  @desc_alim 12000

  def valor_pesaje(kilos, verdes) do
    base = kilos * @tarifa_base

    cond do
      verdes <= 2 -> base * 1.05
      verdes <= 5 -> base * 1.0
      verdes <= 10 -> base * 0.90
      true -> base * 0.70
    end
  end

  def bonificacion_dia(kilos_dia) do
    if kilos_dia >= @bono_kilos, do: @bono_pago, else: 0
  end

  def descuento_alimentacion(dias_trabajados, alimentacion?) do
    if alimentacion?, do: dias_trabajados * @desc_alim, else: 0
  end

  def liquidar_recolector(recolector, pesajes_validos) do
    # Filtramos los pesajes que pertenecen únicamente a este recolector
    pesajes_del_recolector =
      Enum.filter(pesajes_validos, fn p -> p.recolector == recolector.codigo end)

    # Agrupamos por día
    pesajes_por_dia = Enum.group_by(pesajes_del_recolector, fn p -> p.dia end)
    dias_trabajados = map_size(pesajes_por_dia)

    # Convertimos el mapa agrupado en una lista de resultados diarios
    detalle_diario =
      Enum.map(pesajes_por_dia, fn {dia, lista_pesajes} ->
        kilos_dia = Enum.reduce(lista_pesajes, 0, fn p, acc -> acc + p.kilos end)

        valor_pesajes_dia =
          Enum.reduce(lista_pesajes, 0, fn p, acc -> acc + valor_pesaje(p.kilos, p.verdes) end)

        bono_dia = bonificacion_dia(kilos_dia)

        %{dia: dia, kilos: kilos_dia, valor: valor_pesajes_dia, bonificacion: bono_dia}
      end)

    total_kilos = Enum.reduce(detalle_diario, 0, fn d, acc -> acc + d.kilos end)
    suma_pesajes = Enum.reduce(detalle_diario, 0, fn d, acc -> acc + d.valor end)
    total_bonos = Enum.reduce(detalle_diario, 0, fn d, acc -> acc + d.bonificacion end)
    descuento = descuento_alimentacion(dias_trabajados, recolector.alimentacion)

    neto = suma_pesajes + total_bonos - descuento

    %{
      recolector: recolector,
      detalle_diario: detalle_diario,
      dias_trabajados: dias_trabajados,
      total_kilos: total_kilos,
      suma_pesajes: suma_pesajes,
      total_bonos: total_bonos,
      descuento: descuento,
      neto: neto
    }
  end

  def liquidar_todos(recolectores, pesajes_validos) do
    Enum.map(recolectores, fn rec -> liquidar_recolector(rec, pesajes_validos) end)
  end
end
