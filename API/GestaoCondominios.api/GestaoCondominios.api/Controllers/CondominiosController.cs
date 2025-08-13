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
    public class CondominiosController : ControllerBase
    {
        private readonly GestaoCondominiosContext _context;

        public CondominiosController(GestaoCondominiosContext context)
        {
            _context = context;
        }

        // GET: api/Condominios
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Condominio>>> GetCondominios()
        {
            return await _context.Condominios.ToListAsync();
        }

        // GET: api/Condominios/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Condominio>> GetCondominio(int id)
        {
            var condominio = await _context.Condominios.FindAsync(id);

            if (condominio == null)
            {
                return NotFound();
            }

            return condominio;
        }

        // PUT: api/Condominios/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutCondominio(int id, Condominio condominio)
        {
            if (id != condominio.IdCondominio)
            {
                return BadRequest();
            }

            _context.Entry(condominio).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!CondominioExists(id))
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

        // POST: api/Condominios
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Condominio>> PostCondominio(Condominio condominio)
        {
            _context.Condominios.Add(condominio);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetCondominio", new { id = condominio.IdCondominio }, condominio);
        }

        // DELETE: api/Condominios/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteCondominio(int id)
        {
            var condominio = await _context.Condominios.FindAsync(id);
            if (condominio == null)
            {
                return NotFound();
            }

            _context.Condominios.Remove(condominio);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool CondominioExists(int id)
        {
            return _context.Condominios.Any(e => e.IdCondominio == id);
        }
    }
}
