using System;
using System.Collections.Generic;

namespace GestaoCondominios.api.Models;

public partial class GetSaldoAtual
{
    public int IdCondominio { get; set; }

    public string Edificio { get; set; } = null!;

    public decimal SaldoAtual { get; set; }
}
