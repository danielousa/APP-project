using GestaoCondominios.api.Models;

namespace GestaoCondominios.api.DTOs
{
    public class TipoServicoDTO
    {
        public int IdTipoServico { get; set; }

        public string Descricao { get; set; } = null!;

        public DateTime DataCriacao { get; set; }

        public DateTime DataAtualizacao { get; set; }

        public TipoServico DtoToTipoServicoModel()
        {
            TipoServico tipoServico = new TipoServico
            {
                IdTipoServico = this.IdTipoServico,
                Descricao = this.Descricao,
                DataCriacao = this.DataCriacao,
                DataAtualizacao = this.DataAtualizacao
            };

            return tipoServico;
        }

        public TipoServicoDTO ModelTipoServicoToDto(TipoServico tipoServico)
        {
            TipoServicoDTO dto = new TipoServicoDTO
            {
                IdTipoServico = tipoServico.IdTipoServico,
                Descricao = tipoServico.Descricao
            };

            return dto;

        }
    }
}

