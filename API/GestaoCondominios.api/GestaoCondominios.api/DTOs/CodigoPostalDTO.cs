using GestaoCondominios.api.Models;

namespace GestaoCondominios.api.DTOs
{
    public class CodigoPostalDTO
    {
        public string IdCodigoPostal { get; set; } = null!;

        public string Localidade { get; set; } = null!;

        public DateTime? DataCriacao { get; set; }

        public DateTime? DataAtualizacao { get; set; }

        public CodigoPostal DtoToCodigoPostalModel()
        {
            CodigoPostal codigoPostal = new CodigoPostal
            {
                IdCodigoPostal = this.IdCodigoPostal,
                Localidade = this.Localidade,
                DataCriacao = this.DataCriacao,
                DataAtualizacao = this.DataAtualizacao
            };

            return codigoPostal;
        }

        public CodigoPostalDTO ModelCodigoPostalToDto(CodigoPostal codigoPostal)
        {
            CodigoPostalDTO dto = new CodigoPostalDTO
            {
                IdCodigoPostal = codigoPostal.IdCodigoPostal,
                Localidade = codigoPostal.Localidade
            };

            return dto;
        }
    }
}
