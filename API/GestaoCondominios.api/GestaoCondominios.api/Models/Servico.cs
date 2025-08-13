using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace GestaoCondominios.api.Models;

public partial class Servico
{
    [Key]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]

    public int IdServico { get; set; }

    public int IdTipoServico { get; set; }

    public DateTime DataHoraInicio { get; set; }

    public DateTime? DataHoraPrevistaFim { get; set; }

    public int IdUtilizadorGestor { get; set; }

    public decimal ValorServico { get; set; }

    public string? Obs { get; set; }

    public int IdCondominio { get; set; }

    public string? Anexo { get; set; }

    public DateTime DataCriacao { get; set; }

    public DateTime DataAtualizacao { get; set; }

    public virtual Condominio IdCondominioNavigation { get; set; } = null!;

    public virtual TipoServico IdTipoServicoNavigation { get; set; } = null!;

    public virtual Utilizadore IdUtilizadorGestorNavigation { get; set; } = null!;
}
