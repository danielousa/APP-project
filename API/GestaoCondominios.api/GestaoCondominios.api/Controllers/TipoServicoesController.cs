using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using GestaoCondominios.api.DTOs;
using GestaoCondominios.api.Models;

namespace GestaoCondominios.api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TipoServicoesController : ControllerBase
    {
        private readonly GestaoCondominiosContext _context;

        public TipoServicoesController(GestaoCondominiosContext context)
        {
            _context = context;
        }

        // GET: api/TipoServicoes
        [HttpGet]
        public async Task<ActionResult<IEnumerable<TipoServicoDTO>>> GetTipoServicos()
        {
            List<TipoServicoDTO> list = new List<TipoServicoDTO>();

            var tiposServico = await _context.TipoServicos.ToListAsync();

            foreach(var tipoServico in tiposServico)
            {
                list.Add(new TipoServicoDTO().ModelTipoServicoToDto(tipoServico));
            }

            return list;

        }

        // GET: api/TipoServicoes/5
        [HttpGet("{id}")]
        public async Task<ActionResult<TipoServicoDTO>> GetTipoServico(int id)
        {
            var tipoServico = await _context.TipoServicos.Where(ts => ts.IdTipoServico == id).ToListAsync();

            if (tipoServico.Count == 0)
            {
                return NotFound();
            }

            return new TipoServicoDTO().ModelTipoServicoToDto(tipoServico.First());
        }

        // PUT: api/TipoServicoes/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutTipoServico(int id, TipoServicoDTO tipoServico)
        {
            if (id != tipoServico.IdTipoServico)
            {
                return BadRequest();
            }

            if (!TipoServicoExists(id))
            {
                return NotFound();
            }

            TipoServico tipoServicoModel = tipoServico.DtoToTipoServicoModel();

            _context.Entry(tipoServicoModel).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!TipoServicoExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/TipoServicoes
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<TipoServico>> PostTipoServico(TipoServicoDTO tipoServico)
        {
            TipoServico tipoServicoModel = tipoServico.DtoToTipoServicoModel();

            _context.TipoServicos.Add(tipoServicoModel);

            await _context.SaveChangesAsync();

            return CreatedAtAction("GetTipoServico", new { id = tipoServico.IdTipoServico }, tipoServico);
        }

        // DELETE: api/TipoServicoes/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteTipoServico(int id)
        {
            var tipoServico = await _context.TipoServicos.FindAsync(id);
            if (tipoServico == null)
            {
                return NotFound();
            }

            _context.TipoServicos.Remove(tipoServico);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool TipoServicoExists(int id)
        {
            return _context.TipoServicos.Any(e => e.IdTipoServico == id);
        }
    }
}
