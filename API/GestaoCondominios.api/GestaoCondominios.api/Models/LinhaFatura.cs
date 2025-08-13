using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace GestaoCondominios.api.Models;

public partial class LinhaFatura
{
    [Key]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]

    public int IdLinhaFatura { get; set; }

    public string NumeroFatura { get; set; } = null!;

    public string DescricaoPagamento { get; set; } = null!;

    public decimal ValorPagamento { get; set; }

    public DateTime DataCriacao { get; set; }

    public DateTime DataAtualizacao { get; set; }

    public virtual CabecalhoFatura NumeroFaturaNavigation { get; set; } = null!;
}
