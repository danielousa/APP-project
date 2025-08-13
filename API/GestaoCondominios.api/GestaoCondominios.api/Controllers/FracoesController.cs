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
    public class FracoesController : ControllerBase
    {
        private readonly GestaoCondominiosContext _context;

        public FracoesController(GestaoCondominiosContext context)
        {
            _context = context;
        }

        // GET: api/Fracoes
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Fraco>>> GetFracoes()
        {
            return await _context.Fracoes.ToListAsync();
        }

        // GET: api/Fracoes/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Fraco>> GetFraco(int id)
        {
            var fraco = await _context.Fracoes.FindAsync(id);

            if (fraco == null)
            {
                return NotFound();
            }

            return fraco;
        }

        // PUT: api/Fracoes/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutFraco(int id, Fraco fraco)
        {
            if (id != fraco.IdFracao)
            {
                return BadRequest();
            }

            _context.Entry(fraco).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!FracoExists(id))
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

        // POST: api/Fracoes
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Fraco>> PostFraco(Fraco fraco)
        {
            _context.Fracoes.Add(fraco);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetFraco", new { id = fraco.IdFracao }, fraco);
        }

        // DELETE: api/Fracoes/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteFraco(int id)
        {
            var fraco = await _context.Fracoes.FindAsync(id);
            if (fraco == null)
            {
                return NotFound();
            }

            _context.Fracoes.Remove(fraco);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool FracoExists(int id)
        {
            return _context.Fracoes.Any(e => e.IdFracao == id);
        }
    }
}
