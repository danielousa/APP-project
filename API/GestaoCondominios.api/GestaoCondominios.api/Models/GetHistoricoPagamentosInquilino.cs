using System;
using System.Collections.Generic;

namespace GestaoCondominios.api.Models;

public partial class GetHistoricoPagamentosInquilino
{
    public int IdUtilizadorInquilino { get; set; }

    public string Nome { get; set; } = null!;

    public int IdCondominio { get; set; }

    public int IdFracao { get; set; }

    public decimal ValorPagamento { get; set; }
}
