using GestaoCondominios.api.Models;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddCors(o => o.AddPolicy(name: "MyAllowSpecifcOrigins",
      policy =>
      {
          policy.WithOrigins("http://localhost:4200").AllowAnyHeader().AllowAnyMethod();

      }));

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddDbContext<GestaoCondominiosContext>(o => o.UseSqlServer(builder.Configuration.GetConnectionString("ApiConnectionString")));

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.UseCors("MyAllowSpecifcOrigins");

app.Run();
