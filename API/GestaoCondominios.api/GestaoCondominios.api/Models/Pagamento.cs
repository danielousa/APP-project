using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace GestaoCondominios.api.Models;

public partial class Pagamento
{
    [Key]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]

    public int IdPagamento { get; set; }

    public int IdCondominio { get; set; }

    public string FormaPagamento { get; set; } = null!;

    public decimal ValorPagamento { get; set; }

    public string? Obs { get; set; }

    public int IdUtilizadorInquilino { get; set; }

    public DateTime DataCriacao { get; set; }

    public DateTime DataAtualizacao { get; set; }

    public virtual Condominio IdCondominioNavigation { get; set; } = null!;

    public virtual Utilizadore IdUtilizadorInquilinoNavigation { get; set; } = null!;
}
