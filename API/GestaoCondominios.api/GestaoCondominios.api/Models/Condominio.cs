using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace GestaoCondominios.api.Models;

public partial class Condominio
{
    [Key]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]

    public int IdCondominio { get; set; }

    public string Edificio { get; set; } = null!;

    public string Morada { get; set; } = null!;

    public string IdCodigoPostal { get; set; } = null!;

    public string Iban { get; set; } = null!;

    public int Nif { get; set; }

    public decimal Quotas { get; set; }

    public decimal SaldoAtual { get; set; }

    public int IdUtilizadorGestor { get; set; }

    public DateTime DataCriacao { get; set; }

    public DateTime DataAtualizacao { get; set; }

    public bool? Inativo { get; set; }

    public virtual ICollection<CabecalhoFatura> CabecalhoFaturas { get; set; } = new List<CabecalhoFatura>();

    public virtual ICollection<Fraco> Fracos { get; set; } = new List<Fraco>();

    public virtual CodigoPostal IdCodigoPostalNavigation { get; set; } = null!;

    public virtual Utilizadore IdUtilizadorGestorNavigation { get; set; } = null!;

    public virtual ICollection<Notificaco> Notificacos { get; set; } = new List<Notificaco>();

    public virtual ICollection<Pagamento> Pagamentos { get; set; } = new List<Pagamento>();

    public virtual ICollection<Servico> Servicos { get; set; } = new List<Servico>();
}
