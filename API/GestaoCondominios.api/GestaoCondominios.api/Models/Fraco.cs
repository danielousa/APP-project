using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace GestaoCondominios.api.Models;

public partial class Fraco
{
    [Key]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]

    public int IdFracao { get; set; }

    public int ArtigoPerdial { get; set; }

    public decimal Permilagem { get; set; }

    public int IdUtilizador { get; set; }

    public int IdCondominio { get; set; }

    public DateTime? DataCriacao { get; set; }

    public DateTime? DataAtualizacao { get; set; }

    public virtual Condominio IdCondominioNavigation { get; set; } = null!;

    public virtual Utilizadore IdUtilizadorNavigation { get; set; } = null!;
}
