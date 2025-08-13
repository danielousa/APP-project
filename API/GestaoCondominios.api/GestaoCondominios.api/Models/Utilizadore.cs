using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace GestaoCondominios.api.Models;

public partial class Utilizadore
{
    [Key]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]

    public int IdUtilizador { get; set; }

    public string Nome { get; set; } = null!;

    public string ContactoEmail { get; set; } = null!;

    public int ContactoTelefone { get; set; }

    public int Nif { get; set; }

    public byte[] Password { get; set; } = null!;

    public string Morada { get; set; } = null!;

    public string IdCodigoPostal { get; set; } = null!;

    public int IdTipoUtilizador { get; set; }

    public DateTime DataCriacao { get; set; }

    public DateTime DataAtualizacao { get; set; }

    public bool? Inativo { get; set; }

    public virtual ICollection<CabecalhoFatura> CabecalhoFaturas { get; set; } = new List<CabecalhoFatura>();

    public virtual ICollection<Condominio> Condominios { get; set; } = new List<Condominio>();

    public virtual ICollection<Fraco> Fracos { get; set; } = new List<Fraco>();

    public virtual CodigoPostal IdCodigoPostalNavigation { get; set; } = null!;

    public virtual TipoUtilizador IdTipoUtilizadorNavigation { get; set; } = null!;

    public virtual ICollection<Notificaco> NotificacoIdUtilizadorCriadorNavigations { get; set; } = new List<Notificaco>();

    public virtual ICollection<Notificaco> NotificacoIdUtilizadorRecetorNavigations { get; set; } = new List<Notificaco>();

    public virtual ICollection<Pagamento> Pagamentos { get; set; } = new List<Pagamento>();

    public virtual ICollection<Servico> Servicos { get; set; } = new List<Servico>();
}
