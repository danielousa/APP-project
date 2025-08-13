using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace GestaoCondominios.api.Models;

public partial class Notificaco
{
    [Key]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]

    public int IdNotificacao { get; set; }

    public string Descricao { get; set; } = null!;

    public int IdUtilizadorCriador { get; set; }

    public int IdUtilizadorRecetor { get; set; }

    public DateTime DataHora { get; set; }

    public int IdCondominio { get; set; }

    public string? Anexo { get; set; }

    public DateTime DataCriacao { get; set; }

    public DateTime DataAtualizacao { get; set; }

    public virtual Condominio IdCondominioNavigation { get; set; } = null!;

    public virtual Utilizadore IdUtilizadorCriadorNavigation { get; set; } = null!;

    public virtual Utilizadore IdUtilizadorRecetorNavigation { get; set; } = null!;
}
