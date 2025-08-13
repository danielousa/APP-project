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
    public class TipoUtilizadorsController : ControllerBase
    {
        private readonly GestaoCondominiosContext _context;

        public TipoUtilizadorsController(GestaoCondominiosContext context)
        {
            _context = context;
        }

        // GET: api/TipoUtilizadors
        [HttpGet]
        public async Task<ActionResult<IEnumerable<TipoUtilizadorDTO>>> GetTipoUtilizadors()
        {
            List<TipoUtilizadorDTO> list = new List<TipoUtilizadorDTO>();

            var tiposUtilizador = await _context.TipoUtilizadors.ToListAsync();

            foreach( var tipoUtilizador in tiposUtilizador )
            {
                list.Add(new TipoUtilizadorDTO().ModelTipoUtilizadorToDto(tipoUtilizador));
            }

            return list;
        }

        // GET: api/TipoUtilizadors/5
        [HttpGet("{id}")]
        public async Task<ActionResult<TipoUtilizadorDTO>> GetTipoUtilizador(int id)
        {
            var tipoUtilizador = await _context.TipoUtilizadors.Where(tp => tp.IdTipoUtilizador == id).ToListAsync();

            if (tipoUtilizador.Count == 0)
            {
                return NotFound();
            }

            return new TipoUtilizadorDTO().ModelTipoUtilizadorToDto(tipoUtilizador.First());
        }

        // PUT: api/TipoUtilizadors/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutTipoUtilizador(int id, TipoUtilizadorDTO tipoUtilizador)
        {
            if (id != tipoUtilizador.IdTipoUtilizador)
            {
                return BadRequest();
            }

            if(!TipoUtilizadorExists(id))
            {
                return NotFound();
            }

            TipoUtilizador tipoUtilizadorModel = tipoUtilizador.DtoToTipoUtilizadorModel();

            _context.Entry(tipoUtilizadorModel).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!TipoUtilizadorExists(id))
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

        // POST: api/TipoUtilizadors
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<TipoUtilizador>> PostTipoUtilizador(TipoUtilizadorDTO tipoUtilizador)
        {
            TipoUtilizador tipoUtilizadorModel = tipoUtilizador.DtoToTipoUtilizadorModel();


                _context.TipoUtilizadors.Add(tipoUtilizadorModel);

                await _context.SaveChangesAsync();

                return CreatedAtAction("GetTipoUtilizador", new { id = tipoUtilizador.IdTipoUtilizador }, tipoUtilizador);
   
        }

        // DELETE: api/TipoUtilizadors/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteTipoUtilizador(int id)
        {
            var tipoUtilizador = await _context.TipoUtilizadors.FindAsync(id);
            if (tipoUtilizador == null)
            {
                return NotFound();
            }

            _context.TipoUtilizadors.Remove(tipoUtilizador);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool TipoUtilizadorExists(int id)
        {
            return _context.TipoUtilizadors.Any(e => e.IdTipoUtilizador == id);
        }
    }
}
