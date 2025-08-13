using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace GestaoCondominios.api.Models;

public partial class TipoServico
{
    [Key]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public int IdTipoServico { get; set; }

    public string Descricao { get; set; } = null!;

    public DateTime DataCriacao { get; set; }

    public DateTime DataAtualizacao { get; set; }

    public virtual ICollection<Servico> Servicos { get; set; } = new List<Servico>();
}
