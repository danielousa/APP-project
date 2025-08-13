using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace GestaoCondominios.api.Models;

public partial class GestaoCondominiosContext : DbContext
{
    public GestaoCondominiosContext()
    {
    }

    public GestaoCondominiosContext(DbContextOptions<GestaoCondominiosContext> options)
        : base(options)
    {
    }

    public virtual DbSet<CabecalhoFatura> CabecalhoFaturas { get; set; }

    public virtual DbSet<CodigoPostal> CodigoPostals { get; set; }

    public virtual DbSet<Condominio> Condominios { get; set; }

    public virtual DbSet<Fraco> Fracoes { get; set; }

    public virtual DbSet<GetHistoricoPagamentosInquilino> GetHistoricoPagamentosInquilinos { get; set; }

    public virtual DbSet<GetSaldoAtual> GetSaldoAtuals { get; set; }

    public virtual DbSet<LinhaFatura> LinhaFaturas { get; set; }

    public virtual DbSet<Notificaco> Notificacoes { get; set; }

    public virtual DbSet<Pagamento> Pagamentos { get; set; }

    public virtual DbSet<Servico> Servicos { get; set; }

    public virtual DbSet<TipoServico> TipoServicos { get; set; }

    public virtual DbSet<TipoUtilizador> TipoUtilizadors { get; set; }

    public virtual DbSet<Utilizadore> Utilizadores { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        => optionsBuilder.UseSqlServer("name=ApiConnectionString");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<CabecalhoFatura>(entity =>
        {
            entity.HasKey(e => e.NumeroFatura).HasName("PK_CabecalhoFatura_NumeroFatura");

            entity.ToTable("CabecalhoFatura", tb => tb.HasTrigger("RestrictTypeOfUser_CabecalhoFatura"));

            entity.Property(e => e.NumeroFatura).HasMaxLength(7);
            entity.Property(e => e.DataAtualizacao)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.DataCriacao)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.Estado).HasMaxLength(10);

            entity.HasOne(d => d.IdCondominioNavigation).WithMany(p => p.CabecalhoFaturas)
                .HasForeignKey(d => d.IdCondominio)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_CabecalhoFatura_IdCondominio");

            entity.HasOne(d => d.IdUtilizadorInquilinoNavigation).WithMany(p => p.CabecalhoFaturas)
                .HasForeignKey(d => d.IdUtilizadorInquilino)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_CabecalhoFatura_IdUtilizadorInquilino");
        });

        modelBuilder.Entity<CodigoPostal>(entity =>
        {
            entity.HasKey(e => e.IdCodigoPostal).HasName("PK_CodigoPostal_IdCodigoPostal");

            entity.ToTable("CodigoPostal");

            entity.Property(e => e.IdCodigoPostal).HasMaxLength(8);
            entity.Property(e => e.DataAtualizacao)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.DataCriacao)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.Localidade).HasMaxLength(50);
        });

        modelBuilder.Entity<Condominio>(entity =>
        {
            entity.HasKey(e => e.IdCondominio).HasName("PK_Condominios_IdCondominio");

            entity.ToTable(tb => tb.HasTrigger("RestrictTypeOfUser_Condominios"));

            entity.Property(e => e.DataAtualizacao)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.DataCriacao)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.Edificio).HasMaxLength(50);
            entity.Property(e => e.Iban).HasMaxLength(25);
            entity.Property(e => e.IdCodigoPostal).HasMaxLength(8);
            entity.Property(e => e.Inativo).HasDefaultValue(true);
            entity.Property(e => e.Morada).HasMaxLength(80);
            entity.Property(e => e.Quotas).HasColumnType("decimal(5, 2)");
            entity.Property(e => e.SaldoAtual).HasColumnType("decimal(7, 2)");

            entity.HasOne(d => d.IdCodigoPostalNavigation).WithMany(p => p.Condominios)
                .HasForeignKey(d => d.IdCodigoPostal)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Condominios_IdCodigoPostal");

            entity.HasOne(d => d.IdUtilizadorGestorNavigation).WithMany(p => p.Condominios)
                .HasForeignKey(d => d.IdUtilizadorGestor)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Condominios_IdUtilizadorGestor");
        });

        modelBuilder.Entity<Fraco>(entity =>
        {
            entity.HasKey(e => e.IdFracao).HasName("PK_Fracoes_IdFracao");

            entity.HasIndex(e => new { e.IdFracao, e.ArtigoPerdial }, "UK_Fracoes_IdFracao_ArtigoPerdial").IsUnique();

            entity.Property(e => e.DataAtualizacao)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.DataCriacao)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.Permilagem).HasColumnType("decimal(5, 3)");

            entity.HasOne(d => d.IdCondominioNavigation).WithMany(p => p.Fracos)
                .HasForeignKey(d => d.IdCondominio)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Fracoes_IdCondominio");

            entity.HasOne(d => d.IdUtilizadorNavigation).WithMany(p => p.Fracos)
                .HasForeignKey(d => d.IdUtilizador)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Fracoes_IdUtilizador");
        });

        modelBuilder.Entity<GetHistoricoPagamentosInquilino>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("GetHistoricoPagamentosInquilinos");

            entity.Property(e => e.Nome).HasMaxLength(200);
            entity.Property(e => e.ValorPagamento).HasColumnType("decimal(5, 2)");
        });

        modelBuilder.Entity<GetSaldoAtual>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("GetSaldoAtual");

            entity.Property(e => e.Edificio).HasMaxLength(50);
            entity.Property(e => e.IdCondominio).ValueGeneratedOnAdd();
            entity.Property(e => e.SaldoAtual).HasColumnType("decimal(7, 2)");
        });

        modelBuilder.Entity<LinhaFatura>(entity =>
        {
            entity.HasKey(e => e.IdLinhaFatura).HasName("PK_LinhaFatura_IdLinhaFatura");

            entity.ToTable("LinhaFatura");

            entity.Property(e => e.DataAtualizacao)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.DataCriacao)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.DescricaoPagamento).HasMaxLength(200);
            entity.Property(e => e.NumeroFatura).HasMaxLength(7);
            entity.Property(e => e.ValorPagamento).HasColumnType("decimal(5, 2)");

            entity.HasOne(d => d.NumeroFaturaNavigation).WithMany(p => p.LinhaFaturas)
                .HasForeignKey(d => d.NumeroFatura)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_LinhaFatura_NumeroFatura");
        });

        modelBuilder.Entity<Notificaco>(entity =>
        {
            entity.HasKey(e => e.IdNotificacao).HasName("PK_Notificacoes_IdNotificacao");

            entity.Property(e => e.Anexo).HasColumnType("text");
            entity.Property(e => e.DataAtualizacao)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.DataCriacao)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.DataHora).HasColumnType("smalldatetime");
            entity.Property(e => e.Descricao).HasMaxLength(80);

            entity.HasOne(d => d.IdCondominioNavigation).WithMany(p => p.Notificacos)
                .HasForeignKey(d => d.IdCondominio)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Notificacoes_IdCondominio");

            entity.HasOne(d => d.IdUtilizadorCriadorNavigation).WithMany(p => p.NotificacoIdUtilizadorCriadorNavigations)
                .HasForeignKey(d => d.IdUtilizadorCriador)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Notificacoes_IdUtilizadorCriador");

            entity.HasOne(d => d.IdUtilizadorRecetorNavigation).WithMany(p => p.NotificacoIdUtilizadorRecetorNavigations)
                .HasForeignKey(d => d.IdUtilizadorRecetor)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Notificacoes_IdUtilizadorRecetor");
        });

        modelBuilder.Entity<Pagamento>(entity =>
        {
            entity.HasKey(e => e.IdPagamento).HasName("PK_Pagamentos_IdPagamento");

            entity.ToTable(tb =>
                {
                    tb.HasTrigger("RestrictTypeOfUser_Pagamentos");
                    tb.HasTrigger("UpdateSaldoAtual_Pagamentos");
                });

            entity.Property(e => e.DataAtualizacao)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.DataCriacao)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.FormaPagamento).HasMaxLength(50);
            entity.Property(e => e.Obs).HasMaxLength(200);
            entity.Property(e => e.ValorPagamento).HasColumnType("decimal(5, 2)");

            entity.HasOne(d => d.IdCondominioNavigation).WithMany(p => p.Pagamentos)
                .HasForeignKey(d => d.IdCondominio)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Pagamentos_IdCondominio");

            entity.HasOne(d => d.IdUtilizadorInquilinoNavigation).WithMany(p => p.Pagamentos)
                .HasForeignKey(d => d.IdUtilizadorInquilino)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Pagamentos_IdUtilizadorInquilino");
        });

        modelBuilder.Entity<Servico>(entity =>
        {
            entity.HasKey(e => e.IdServico).HasName("PK_Servicos_IdServico");

            entity.ToTable(tb =>
                {
                    tb.HasTrigger("RestrictTypeOfUser_Servicos");
                    tb.HasTrigger("UpdateSaldoAtual_Servicos");
                });

            entity.Property(e => e.Anexo).HasColumnType("text");
            entity.Property(e => e.DataAtualizacao)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.DataCriacao)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.DataHoraInicio).HasColumnType("smalldatetime");
            entity.Property(e => e.DataHoraPrevistaFim).HasColumnType("smalldatetime");
            entity.Property(e => e.Obs).HasMaxLength(200);
            entity.Property(e => e.ValorServico).HasColumnType("decimal(5, 2)");

            entity.HasOne(d => d.IdCondominioNavigation).WithMany(p => p.Servicos)
                .HasForeignKey(d => d.IdCondominio)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Servicos_IdCondominio");

            entity.HasOne(d => d.IdTipoServicoNavigation).WithMany(p => p.Servicos)
                .HasForeignKey(d => d.IdTipoServico)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Servicos_IdTipoServico");

            entity.HasOne(d => d.IdUtilizadorGestorNavigation).WithMany(p => p.Servicos)
                .HasForeignKey(d => d.IdUtilizadorGestor)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Servicos_IdUtilizadorGestor");
        });

        modelBuilder.Entity<TipoServico>(entity =>
        {
            entity.HasKey(e => e.IdTipoServico).HasName("PK_TipoServico_IdTipoServico");

            entity.ToTable("TipoServico");

            entity.Property(e => e.DataAtualizacao)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.DataCriacao)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.Descricao).HasMaxLength(50);
        });

        modelBuilder.Entity<TipoUtilizador>(entity =>
        {
            entity.HasKey(e => e.IdTipoUtilizador).HasName("PK_TipoUtilizador_IdTipoUtilizador");

            entity.ToTable("TipoUtilizador");

            entity.Property(e => e.DataAtualizacao)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.DataCriacao)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.Designcacao).HasMaxLength(50);
        });

        modelBuilder.Entity<Utilizadore>(entity =>
        {
            entity.HasKey(e => e.IdUtilizador).HasName("PK_Utilizadores_IdUtilizador");

            entity.HasIndex(e => e.ContactoEmail, "UK_Utilizadores_ContactoEmail").IsUnique();

            entity.Property(e => e.ContactoEmail).HasMaxLength(30);
            entity.Property(e => e.DataAtualizacao)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.DataCriacao)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.IdCodigoPostal).HasMaxLength(8);
            entity.Property(e => e.Inativo).HasDefaultValue(true);
            entity.Property(e => e.Morada).HasMaxLength(80);
            entity.Property(e => e.Nome).HasMaxLength(200);
            entity.Property(e => e.Password).HasMaxLength(64);

            entity.HasOne(d => d.IdCodigoPostalNavigation).WithMany(p => p.Utilizadores)
                .HasForeignKey(d => d.IdCodigoPostal)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Utilizadores_IdCodigoPostal");

            entity.HasOne(d => d.IdTipoUtilizadorNavigation).WithMany(p => p.Utilizadores)
                .HasForeignKey(d => d.IdTipoUtilizador)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Utilizadores_IdTipoUtilizador");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
