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
    public class CabecalhoFaturasController : ControllerBase
    {
        private readonly GestaoCondominiosContext _context;

        public CabecalhoFaturasController(GestaoCondominiosContext context)
        {
            _context = context;
        }

        // GET: api/CabecalhoFaturas
        [HttpGet]
        public async Task<ActionResult<IEnumerable<CabecalhoFatura>>> GetCabecalhoFaturas()
        {
            return await _context.CabecalhoFaturas.ToListAsync();
        }

        // GET: api/CabecalhoFaturas/5
        [HttpGet("{id}")]
        public async Task<ActionResult<CabecalhoFatura>> GetCabecalhoFatura(string id)
        {
            var cabecalhoFatura = await _context.CabecalhoFaturas.FindAsync(id);

            if (cabecalhoFatura == null)
            {
                return NotFound();
            }

            return cabecalhoFatura;
        }

        // PUT: api/CabecalhoFaturas/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutCabecalhoFatura(string id, CabecalhoFatura cabecalhoFatura)
        {
            if (id != cabecalhoFatura.NumeroFatura)
            {
                return BadRequest();
            }

            _context.Entry(cabecalhoFatura).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!CabecalhoFaturaExists(id))
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

        // POST: api/CabecalhoFaturas
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<CabecalhoFatura>> PostCabecalhoFatura(CabecalhoFatura cabecalhoFatura)
        {
            _context.CabecalhoFaturas.Add(cabecalhoFatura);
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                if (CabecalhoFaturaExists(cabecalhoFatura.NumeroFatura))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtAction("GetCabecalhoFatura", new { id = cabecalhoFatura.NumeroFatura }, cabecalhoFatura);
        }

        // DELETE: api/CabecalhoFaturas/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteCabecalhoFatura(string id)
        {
            var cabecalhoFatura = await _context.CabecalhoFaturas.FindAsync(id);
            if (cabecalhoFatura == null)
            {
                return NotFound();
            }

            _context.CabecalhoFaturas.Remove(cabecalhoFatura);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool CabecalhoFaturaExists(string id)
        {
            return _context.CabecalhoFaturas.Any(e => e.NumeroFatura == id);
        }
    }
}
