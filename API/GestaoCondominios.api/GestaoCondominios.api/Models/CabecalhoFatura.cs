using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace GestaoCondominios.api.Models;

public partial class CabecalhoFatura
{
    public string NumeroFatura { get; set; } = null!;

    public DateOnly Data { get; set; }

    public int IdUtilizadorInquilino { get; set; }

    public int IdCondominio { get; set; }

    public string Estado { get; set; } = null!;

    public DateTime DataCriacao { get; set; }

    public DateTime DataAtualizacao { get; set; }

    public virtual Condominio IdCondominioNavigation { get; set; } = null!;

    public virtual Utilizadore IdUtilizadorInquilinoNavigation { get; set; } = null!;

    public virtual ICollection<LinhaFatura> LinhaFaturas { get; set; } = new List<LinhaFatura>();
}
