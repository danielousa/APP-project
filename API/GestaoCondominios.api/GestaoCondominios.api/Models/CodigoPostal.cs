using System;
using System.Collections.Generic;

namespace GestaoCondominios.api.Models;

public partial class CodigoPostal
{
    public string IdCodigoPostal { get; set; } = null!;

    public string Localidade { get; set; } = null!;

    public DateTime? DataCriacao { get; set; }

    public DateTime? DataAtualizacao { get; set; }

    public virtual ICollection<Condominio> Condominios { get; set; } = new List<Condominio>();

    public virtual ICollection<Utilizadore> Utilizadores { get; set; } = new List<Utilizadore>();
}
