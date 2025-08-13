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
    public class NotificacoesController : ControllerBase
    {
        private readonly GestaoCondominiosContext _context;

        public NotificacoesController(GestaoCondominiosContext context)
        {
            _context = context;
        }

        // GET: api/Notificacoes
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Notificaco>>> GetNotificacoes()
        {
            return await _context.Notificacoes.ToListAsync();
        }

        // GET: api/Notificacoes/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Notificaco>> GetNotificaco(int id)
        {
            var notificaco = await _context.Notificacoes.FindAsync(id);

            if (notificaco == null)
            {
                return NotFound();
            }

            return notificaco;
        }

        // PUT: api/Notificacoes/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutNotificaco(int id, Notificaco notificaco)
        {
            if (id != notificaco.IdNotificacao)
            {
                return BadRequest();
            }

            _context.Entry(notificaco).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!NotificacoExists(id))
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

        // POST: api/Notificacoes
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Notificaco>> PostNotificaco(Notificaco notificaco)
        {
            _context.Notificacoes.Add(notificaco);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetNotificaco", new { id = notificaco.IdNotificacao }, notificaco);
        }

        // DELETE: api/Notificacoes/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteNotificaco(int id)
        {
            var notificaco = await _context.Notificacoes.FindAsync(id);
            if (notificaco == null)
            {
                return NotFound();
            }

            _context.Notificacoes.Remove(notificaco);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool NotificacoExists(int id)
        {
            return _context.Notificacoes.Any(e => e.IdNotificacao == id);
        }
    }
}
