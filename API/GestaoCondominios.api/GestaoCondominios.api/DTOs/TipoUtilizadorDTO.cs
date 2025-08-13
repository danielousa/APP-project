using GestaoCondominios.api.Models;

namespace GestaoCondominios.api.DTOs
{
    public class TipoUtilizadorDTO
    {
        public int IdTipoUtilizador { get; set; }

        public string Designcacao { get; set; } = null!;

        public DateTime? DataCriacao { get; set; } = null;

        public DateTime? DataAtualizacao { get; set; } = null;

        public TipoUtilizador DtoToTipoUtilizadorModel()
        {
            TipoUtilizador tipoUtilizador = new TipoUtilizador
            {
                IdTipoUtilizador = this.IdTipoUtilizador,
                Designcacao = this.Designcacao,
                DataCriacao = this.DataCriacao,
                DataAtualizacao = this.DataAtualizacao
            };

            return tipoUtilizador;
        }

        public TipoUtilizadorDTO ModelTipoUtilizadorToDto(TipoUtilizador tipoUtilizador)
        {
            TipoUtilizadorDTO dto = new TipoUtilizadorDTO
            {
                IdTipoUtilizador = tipoUtilizador.IdTipoUtilizador,
                Designcacao = tipoUtilizador.Designcacao
            };

            return dto;
        }
    }
}