using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using GestaoCondominios.api.Models;

namespace GestaoCondominios.api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class LinhaFaturasController : ControllerBase
    {
        private readonly GestaoCondominiosContext _context;

        public LinhaFaturasController(GestaoCondominiosContext context)
        {
            _context = context;
        }

        // GET: api/LinhaFaturas
        [HttpGet]
        public async Task<ActionResult<IEnumerable<LinhaFatura>>> GetLinhaFaturas()
        {
            return await _context.LinhaFaturas.ToListAsync();
        }

        // GET: api/LinhaFaturas/5
        [HttpGet("{id}")]
        public async Task<ActionResult<LinhaFatura>> GetLinhaFatura(int id)
        {
            var linhaFatura = await _context.LinhaFaturas.FindAsync(id);

            if (linhaFatura == null)
            {
                return NotFound();
            }

            return linhaFatura;
        }

        // PUT: api/LinhaFaturas/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutLinhaFatura(int id, LinhaFatura linhaFatura)
        {
            if (id != linhaFatura.IdLinhaFatura)
            {
                return BadRequest();
            }

            _context.Entry(linhaFatura).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!LinhaFaturaExists(id))
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

        // POST: api/LinhaFaturas
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<LinhaFatura>> PostLinhaFatura(LinhaFatura linhaFatura)
        {
            _context.LinhaFaturas.Add(linhaFatura);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetLinhaFatura", new { id = linhaFatura.IdLinhaFatura }, linhaFatura);
        }

        // DELETE: api/LinhaFaturas/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteLinhaFatura(int id)
        {
            var linhaFatura = await _context.LinhaFaturas.FindAsync(id);
            if (linhaFatura == null)
            {
                return NotFound();
            }

            _context.LinhaFaturas.Remove(linhaFatura);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool LinhaFaturaExists(int id)
        {
            return _context.LinhaFaturas.Any(e => e.IdLinhaFatura == id);
        }
    }
}
