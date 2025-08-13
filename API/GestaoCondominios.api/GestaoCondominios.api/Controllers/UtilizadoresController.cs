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
    public class UtilizadoresController : ControllerBase
    {
        private readonly GestaoCondominiosContext _context;

        public UtilizadoresController(GestaoCondominiosContext context)
        {
            _context = context;
        }

        // GET: api/Utilizadores
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Utilizadore>>> GetUtilizadores()
        {
            return await _context.Utilizadores.ToListAsync();
        }

        // GET: api/Utilizadores/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Utilizadore>> GetUtilizadore(int id)
        {
            var utilizadore = await _context.Utilizadores.FindAsync(id);

            if (utilizadore == null)
            {
                return NotFound();
            }

            return utilizadore;
        }

        // PUT: api/Utilizadores/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutUtilizadore(int id, Utilizadore utilizadore)
        {
            if (id != utilizadore.IdUtilizador)
            {
                return BadRequest();
            }

            _context.Entry(utilizadore).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!UtilizadoreExists(id))
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

        // POST: api/Utilizadores
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Utilizadore>> PostUtilizadore(Utilizadore utilizadore)
        {
            _context.Utilizadores.Add(utilizadore);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetUtilizadore", new { id = utilizadore.IdUtilizador }, utilizadore);
        }

        // DELETE: api/Utilizadores/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteUtilizadore(int id)
        {
            var utilizadore = await _context.Utilizadores.FindAsync(id);
            if (utilizadore == null)
            {
                return NotFound();
            }

            _context.Utilizadores.Remove(utilizadore);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool UtilizadoreExists(int id)
        {
            return _context.Utilizadores.Any(e => e.IdUtilizador == id);
        }
    }
}
