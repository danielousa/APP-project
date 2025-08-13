using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace GestaoCondominios.api.Models;

public partial class TipoUtilizador
{
    [Key]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public int IdTipoUtilizador { get; set; }

    public string Designcacao { get; set; } = null!;

    public DateTime? DataCriacao { get; set; }

    public DateTime? DataAtualizacao { get; set; }

    public virtual ICollection<Utilizadore> Utilizadores { get; set; } = new List<Utilizadore>();
}
