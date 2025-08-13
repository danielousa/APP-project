import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CreateTipoUtilizadorComponent } from './create-tipo-utilizador.component';

describe('CreateTipoUtilizadorComponent', () => {
  let component: CreateTipoUtilizadorComponent;
  let fixture: ComponentFixture<CreateTipoUtilizadorComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [CreateTipoUtilizadorComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(CreateTipoUtilizadorComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
